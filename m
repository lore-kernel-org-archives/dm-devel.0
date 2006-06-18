From: "John Steinman" <john.steinman46@gmail.com>
Subject: Should the device-mapper and multipath be using the NAA
	with a type prefix?
Date: Sun, 18 Jun 2006 06:26:47 -0600
Message-ID: <9e0ffe70606180526k33f2bf7w35ae0d33453603f7@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============1395461939=="
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

--===============1395461939==
Content-Type: multipart/alternative;
	boundary="----=_Part_12013_20818784.1150633607762"

------=_Part_12013_20818784.1150633607762
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Should the device-mapper and multipath be using the NAA with a type prefix?

A type 3 prefix is being reported with the NAA:

# scsi_id -p 0x83 -s /class/scsi_generic/sg4 -g

3600601600f50100014d66db7da7eda11

dmsetup -j 254 -m 7 --noopencount --noheading -c info
3600601600f50100014d66db7da7eda11:254:7:L--w:-1:1:1:3600601600f50100014d66db7da7eda11

Reporting of the NAA with a type prefix appears to be in conflict with
NAVICLI which reports just the NAA.

  --
John F. Steinman

------=_Part_12013_20818784.1150633607762
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline



<p class="MsoNormal">Should the device-mapper and multipath be using the NAA with
a type prefix?</p>


<p class="MsoNormal">A type 3 prefix is being reported with the NAA:<br>
</p>


<p class="MsoNormal"># scsi_id -p 0x83 -s /class/scsi_generic/sg4 -g</p>


<p class="MsoNormal">3600601600f50100014d66db7da7eda11</p>




<p class="MsoNormal">dmsetup -j 254 -m 7 --noopencount --noheading -c info</p>




3600601600f50100014d66db7da7eda11:254:7:L--w:-1:1:1:3600601600f50100014d66db7da7eda11<br>
<br>
Reporting of the NAA with a type prefix appears to be in
conflict with NAVICLI which reports just the NAA.<br>
<br>
&nbsp;


-- <br>John F. Steinman<br>

------=_Part_12013_20818784.1150633607762--


--===============1395461939==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============1395461939==--
