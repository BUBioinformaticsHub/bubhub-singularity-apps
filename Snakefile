
rule all:
  input:
    'bamcmp/bamcmp.simg',
    'star-fusion/star-fusion.simg'

rule base:
  input: 'Singularity'
  output: 'base.simg'
  shell:
    '''/usr/local/bin/singularity build {output} {input} && chmod a+rx {output}'''

rule simg:
  input:
    base='base.simg',
    recipe='{tool}/Singularity'
  output:
    simg='{tool}/{tool}.simg'
  shell:
    '/usr/local/bin/singularity build {output} {input.recipe} && chmod a+rx {output}'
