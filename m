From: "NC SPIRIT" <ncsprite@gmail.com>
Subject: "sginfo" command failed on /dev/mapper/mpath0
Date: Wed, 27 Aug 2008 00:44:14 +0800
Message-ID: <a956c22b0808260944m2000bf06v17ed8f6c61ad7c38@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============0026925347=="
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

--===============0026925347==
Content-Type: multipart/alternative;
	boundary="----=_Part_9660_18413818.1219769055645"

------=_Part_9660_18413818.1219769055645
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hi, all

I have met some errors when running sginfo command to the DM device. Here is
the error message:

# sginfo  /dev/mapper/mpath0
A device name that understands SCSI commands is required
Couldn't find sg device corresponding to /dev/mapper/mpath0

However, I ever noticed that the latest RHEL would support persistent
reservation for DM-MPIO. I don't have a chance to try it yet. Anyone can
shed some light on how the PR is implemented? Currently the device mapper
pseudo device does not even respond to SCSI 3 inquiry command...

thx a lot!

Tim

------=_Part_9660_18413818.1219769055645
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

<div dir="ltr"><div>Hi, all</div>
<div>&nbsp;</div>
<div>I have met some errors when running sginfo command to the DM device. Here is the error message:</div>
<div>&nbsp;</div>
<div># sginfo&nbsp; /dev/mapper/mpath0<br>A device name that understands SCSI commands is required<br>Couldn&#39;t find sg device corresponding to /dev/mapper/mpath0</div>
<div>&nbsp;</div>
<div>However, I ever noticed that the latest RHEL would support&nbsp;persistent reservation&nbsp;for DM-MPIO. I don&#39;t have a chance to try it yet. Anyone can shed some light on how the PR is implemented? Currently the device mapper pseudo device does not even respond to SCSI 3 inquiry command...</div>

<div>&nbsp;</div>
<div>thx a lot!</div>
<div>&nbsp;</div>
<div>Tim</div></div>

------=_Part_9660_18413818.1219769055645--


--===============0026925347==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============0026925347==--
