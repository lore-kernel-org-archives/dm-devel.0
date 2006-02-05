From: Bernd Zeimetz <bernd@bzed.de>
Subject: how to "slow down" multipath
Date: Sun, 05 Feb 2006 03:16:10 +0100
Message-ID: <43E55FEA.9010101@bzed.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
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

Hi,

we unfortunately have some errors on SCSI level on the FC bus to an EMC
CX sometimes, we'll have to figure out if that's a problem with the HBAs
or the CX. But in the meantime it would be good to have a way to stop
multipath(d) from swtiching back to the path witch had the scsi error
ASAP, as these errors repeat within seconds, which results in a lot of
path switches just because multipathd allready uses the default path
again. Although switching back to the normal path is normally nothing
bad, in this case it's something we'd prefer not to have.

Any ideas to this?


Thanks a lot,
best regards,


Bernd
