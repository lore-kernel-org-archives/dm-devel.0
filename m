From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Adding target device caused an alignment inconsistency
Date: Tue, 1 Mar 2016 14:25:35 -0800
Message-ID: <56D616DF.3010505@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
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

Hello,

With kernel 4.4.0 (openSuSE Tumbleweed) I see the following message 
appear systematically in the kernel log if udev reports a new path to 
multipathd:

[958779.753012] device-mapper: table: 254:0: adding target device sdg 
caused an alignment inconsistency: physical_block_size=4096, 
logical_block_size=512, alignment_offset=0, start=0

This did not happen with previous kernel versions. This causes the 
initiator to report the new paths as faulty until I run the following 
command:

echo reconfigure | multipathd -k

Is this a know issue?

Thanks,

Bart.
