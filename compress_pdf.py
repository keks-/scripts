#!/usr/bin/env python

import click
import shlex
import os
import subprocess
import sys


@click.command()
@click.option('--level', type=click.IntRange(1, 4), default=1,
              help='quality level, decreasing from 1 to 4')
@click.argument('input', type=str)
@click.argument('output', type=str)
def cli(input, output, level):
    """Small script to reduce the size of the INPUT .pdf file and save it as
    OUTPUT. Requires ghostscript to do lossy recompressing. Based on shrinkpdf
    from Alfred Klomp."""
    quality = {1: 'prepress', 2: 'printer', 3: 'ebook', 4: 'screen'}
    cmd = ('gs -sDEVICE=pdfwrite -dCompatibilityLevel=1.4 '
           '-dEmbedAllFonts=true -dSubsetFonts=true -dPDFSETTINGS=/{0} '
           '-dNOPAUSE -dQUIET -dBATCH -sOutputFile={1} '
           '{2}'.format(quality[level], output, input))
    p = subprocess.run(shlex.split(cmd), stderr=sys.stdout)
    try:
        p.check_returncode()
    except subprocess.CalledProcessError as e:
        raise e
    else:
        click.echo(click.style('== Done ==', fg='green'))
        click.echo('{0} {1} {2}'.format(get_filesize(input), input,
                                        click.style('(old)', fg='red')))
        click.echo('{0} {1} {2}'.format(get_filesize(output), output,
                                        click.style('(new)', fg='red')))


def get_filesize(filename):
    """Returns the size of file in MiB/KiB as string"""
    bytes = os.path.getsize(filename)
    abbrevs = [(1 << 20, 'MiB'),
               (1 << 10, 'KiB')]
    for factor, suffix in abbrevs:
        if bytes >= factor:
            break
    return '{0:.1f}{1}'.format(bytes / factor, suffix)


if __name__ == '__main__':
    cli()
