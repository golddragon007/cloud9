
<h2>Services</h2>

<ul>
  <li><a href='./phpinfo.php'>PhpInfo</a></li>
  <li><a href='./selenium/vnc.html?port=8081&autoconnect=true'>Selenium</a></li>
  <li><a href='./solr/'>ApacheSolr</a></li>
  <li><a href='./maildev/'>MailDev</a></li>
  <li><a href='./phpmyadmin/'>PhpMyAdmin</a></li>
  <?php
    if (file_exists("/opt/frp/frpc.ini")){
        $contents = file_get_contents("/opt/frp/frpc.ini");
        if (preg_match("/subdomain = (.*)/", $contents, $output_array)){
            $url = $output_array[1];
            print "<li><a href='https://$url.c9.fpfis.tech.ec.europa.eu/'>Cloud9 Europa domain</a></li>";
        }
    }
    ?>
</ul> 

<h2>Directories</h2>

<?php 

echo mkmap('.', 1, True);


function mkmap($dir, $depth = 1, $only_dirs = True,$template = False) {
    if (False === $template) {
        $template = array('<ul>','<li><a href="./{path}/">{file}</a></li>','</ul>');
    }
    $response = '';
    $folder = opendir ($dir);

    while ($file = readdir ($folder)) {
        if ($file != '.' && $file != '..' && strpos ( $file, ".") !== 0) {           
            $pathfile = $dir.'/'.$file;
            if ($only_dirs && !is_dir($pathfile))
                continue;
            $response .= str_replace(array('{path}','{file}'), array($pathfile, $file), $template[1]);
            if (is_dir($pathfile) && $depth - 1 > 0)
                $response .= mkmap($pathfile, $depth - 1, $only_dirs, $template);
        }
    }
    closedir ($folder);
    return $template[0] . $response . $template[2];
}

