��          \               �   ]   �      �   	     X       q  p   v  h   �  �  P     �     g       y   �  T    �   `  h      Adjust file paths as appropriate; we recomment specifying the full path to the repmgr binary. Automatic failover Databases If using automatic failover, the following repmgrd options *must* be set in repmgr.conf: Note that the `--log-to-file` option will cause output generated by the repmgr command, when executed by repmgrd, to be logged to the same destination configured to receive log output for repmgrd. See `repmgr.conf.sample` for further repmgrd-specific settings. When failover is set to `automatic`, upon detecting failure of the current primary, repmgrd will execute one of: terraform state mv openstack_compute_instance_v2.databases[0] openstack_compute_instance_v2.databases[1] Project-Id-Version: Research Data Management (RDM) 0.0.3
Report-Msgid-Bugs-To: 
POT-Creation-Date: 2023-06-23 14:42-0400
PO-Revision-Date: YEAR-MO-DA HO:MI+ZONE
Last-Translator: FULL NAME <EMAIL@ADDRESS>
Language: fr
Language-Team: fr <LL@li.org>
Plural-Forms: nplurals=2; plural=(n > 1);
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Generated-By: Babel 2.12.1
 Adaptez les chemins des fichiers en conséquence ; nous recommandons de spécifier le chemin complet vers l'exécutable repmgr. Basculement automatique Bases de données Si vous utilisez la bascule automatique, les options suivantes de repmgrd *doivent* être configurées dans repmgr.conf : Notez que l'option `--log-to-file` provoque l'enregistrement de la sortie générée par la commande repmgr, lorsqu'elle est exécutée par repmgrd, dans la même destination configurée pour recevoir la sortie de journal pour repmgrd. Consultez le fichier `repmgr.conf.sample` pour des paramètres supplémentaires spécifiques à repmgrd. Lorsque la bascule est configurée sur `automatic`, dès qu'une défaillance du serveur primaire actuel est détectée, repmgrd exécutera l'une des opérations suivantes : terraform state mv openstack_compute_instance_v2.databases[0] openstack_compute_instance_v2.databases[1] 