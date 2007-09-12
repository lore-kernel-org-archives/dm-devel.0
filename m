From: "David Strand" <dpstrand@gmail.com>
Subject: alias multipath by fibre channel AL_PA instead of wwid?
Date: Tue, 11 Sep 2007 18:56:59 -0700
Message-ID: <448b15030709111856t6aa3808v50b7db9c2731e263@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============0071552314=="
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

--===============0071552314==
Content-Type: multipart/alternative;
	boundary="----=_Part_16486_28023455.1189562219435"

------=_Part_16486_28023455.1189562219435
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

I see that multipath persistant link options are very dependent on knowing
the disk wwid. In my setup, I will not know wwid but each drive is hardware
strapped to obtain a hard AL_PA (disks are on a fibre channel arbitrated
loop). Is there a way to setup alias names based on this information without
knowing the wwid?

------=_Part_16486_28023455.1189562219435
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

I see that multipath persistant link options are very dependent on knowing the disk wwid. In my setup, I will not know wwid but each drive is hardware strapped to obtain a hard AL_PA (disks are on a fibre channel arbitrated loop). Is there a way to setup alias names based on this information without knowing the wwid?
<br>

------=_Part_16486_28023455.1189562219435--


--===============0071552314==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============0071552314==--
