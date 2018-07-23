deploy_dir = '/projectnb/bubhub/singularity'

imgs = [
    'bamcmp.simg',
    'star-fusion.simg',
    'bcl2fastq.simg'
]
deployed_imgs = expand('{deploy_dir}/{img}',
  deploy_dir=deploy_dir,
  img=imgs
)

# since some of these rules have to be run as root, the .snakemake
# directory has restrictive permissions
# whenever the workflow finishes set mode wide open on the dir
shell('sudo chmod 777 -R .snakemake')

rule all:
  input: deployed_imgs

rule base:
  input: 'Singularity'
  output: 'base.simg'
  shell:
    '''sudo /usr/local/bin/singularity build {output} {input} && sudo chmod a+rx {output}'''

rule simg:
  input:
    base='base.simg',
    recipe='{tool}/Singularity'
  output:
    simg='{tool}/{tool}.simg'
  shell:
    'sudo /usr/local/bin/singularity build {output} {input.recipe} && sudo chmod a+rx {output}'

rule deploy:
  input: '{img}/{img}.simg'
  output: deploy_dir+'/{img}.simg'
  params: deploy_dir=deploy_dir
  shell:
    '''ls {params.deploy_dir} && 
       cp {input} {output}
    '''
