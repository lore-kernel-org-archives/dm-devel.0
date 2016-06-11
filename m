From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: [RFE] multipath-tools: HPE StoreVirtual 4000 Storage
 (LeftHand OS, formerly SAN/iQ)
Date: Sat, 11 Jun 2016 21:27:17 +0200
Message-ID: <18d0cc6f-af99-3032-305b-283b4df4ed98@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

Hi,

Moreover, all other HPE Storage families(XP, 3PAR and MSA) are well supported.
And for unknown reasons this one has never been supported by default.

They are still sold:
 https://www.hpe.com/storage/StoreVirtual4000
 https://www.hpe.com/us/en/storage/storevirtual.html

- FC models(4330FC/4730FC) are identified as "LEFTHAND"/"P4000 disk" :
    https://www.citrix.com/blogs/2013/10/02/hp-p4000-multipath-config-file/

- iSCSI ones as "LEFTHAND"/"iSCSIDisk" :
    https://marc.info/?l=dm-devel&m=125432891514890
