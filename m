From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH] Fix priorities handling for multipathing
Date: Wed, 08 Nov 2006 11:50:27 +0100
Message-ID: <4551B673.7030107@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------010500070209030807080204"
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
To: christophe varoqui <christophe.varoqui@free.fr>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

This is a multi-part message in MIME format.
--------------010500070209030807080204
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: quoted-printable

Hi Christophe,

rr_weight=3Dpriorities is currently broken as the 'minio' parameter is=20
incremented for each path. So when we have enough paths the minio=20
parameter will eventually overflow and generate an invalid map.
And we don't disassemble such a map properly, either.

Please apply.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke			hare@suse.de
SuSE Linux Products GmbH		S390 & zSeries
Maxfeldstra=DFe 5				+49 911 74053 688
90409 N=FCrnberg				http://www.suse.de

--------------010500070209030807080204
Content-Type: text/plain;
	name*0="0011-multipath-devices-are-not-created-for-the-Luns-having-8-pat";
	name*1="hs.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
	filename*0="0011-multipath-devices-are-not-created-for-the-Luns-having-8";
	filename*1="-paths.txt"


--------------010500070209030807080204
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--------------010500070209030807080204--
