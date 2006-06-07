From: "Kevin Foote" <kevin.foote@gmail.com>
Subject: testing multipath failover
Date: Wed, 7 Jun 2006 13:44:06 -0400
Message-ID: <5fb0f77b0606071044k55620d6dq6b6f25821e7388db@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============0591935328=="
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
List-Id: dm-devel.ids

--===============0591935328==
Content-Type: multipart/alternative;
	boundary="----=_Part_6064_8518094.1149702246614"

------=_Part_6064_8518094.1149702246614
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hi all
I'm looking for a pointer on a bonnie++ command to test my multipath
failover setup. currently my command looks like this. Just wondering if
there is a better suited to mimic db (oracle) access.

> bonnie++ -d /mnt/san/vol.oracle -s 256 -n 50 -r 128 -x 5 -u 0

Things seem to work when i unplug the network but there is a little pause
and Id like to eliminate that if possible.

-- 
:wq!
kevin.foote

------=_Part_6064_8518094.1149702246614
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hi all <br>
I'm looking for a pointer on a bonnie++ command to test my multipath
failover setup. currently my command looks like this. Just wondering if
there is a better suited to mimic db (oracle) access.<br>
<br>
&gt; bonnie++ -d /mnt/san/vol.oracle -s 256 -n 50 -r 128 -x 5 -u 0<br>
<br>
Things seem to work when i unplug the network but there is a little pause and Id like to eliminate that if possible.<br>
<br>
-- <br>:wq!<br>kevin.foote

------=_Part_6064_8518094.1149702246614--


--===============0591935328==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============0591935328==--
