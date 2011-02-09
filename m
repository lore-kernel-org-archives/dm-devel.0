From: Peter Volkov <peter.volkov@gmail.com>
Subject: multipath: rdac on IBM 1746 (SAS connection to DS3512)
Date: Wed, 09 Feb 2011 12:37:31 +0300
Message-ID: <1297244251.10348.14.camel@tablet>
Reply-To: device-mapper development <dm-devel@redhat.com>
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
To: dm-devel@redhat.com
List-Id: dm-devel.ids

Hi. We have Bladecenter H with HS22 servers inside. All servers have 
0b:00.0 SCSI storage controller: LSI Logic / Symbios Logic SAS1064ET
PCI-Express Fusion-MPT SAS (rev 10)
with two possible external SAS connections which we use to connect them
with DS3512 (IBM datastorage) using two SAS cables and thus multipath
configuration is in place. We use ubuntu 10.04 here and since in-stock
scsi_dh_rdac kernel module does not support IBM 1746 devices I've
patched it and rebuild kernel. Now, as I modproble module I see the
following in dmesg:

[   27.861388] sd 0:0:2:1: rdac: LUN 1 (owned)
[   27.861836] sd 0:0:3:1: rdac: LUN 1 (unowned)
[   27.861840] rdac: device handler registered

That's Ok, but multipath output does not have rdac:

root@btv1:~# multipath -l
vod (360080e50001baa46000025834d501798) dm-0 IBM     ,1746      FASt
[size=13T][features=0][hwhandler=0]
\_ round-robin 0 [prio=0][active]
 \_ 0:0:2:1 sdc 8:32  [active][undef]
\_ round-robin 0 [prio=0][enabled]
 \_ 0:0:3:1 sdd 8:48  [active][undef]


Is this normal? On Gentoo system connected to the same DS I see:

mon1 ~ # multipath -l
vod (360080e50001baa46000025834d501798) dm-0 IBM,1746      FAStT
size=13T features='3 queue_if_no_path pg_init_retries 50' hwhandler='1
rdac' wp=rw
|-+- policy='round-robin 0' prio=-1 status=active
| `- 0:0:2:1 sdc 8:32 active undef running
`-+- policy='round-robin 0' prio=-1 status=enabled
  `- 0:0:3:1 sdd 8:48 active undef running

Could you tell me what's hwhandler and why it's 0 in one case and 1 in
another.

Many thanks for any explanations in advance,
-- 
Peter.
