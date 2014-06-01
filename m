From: Sebastian Herbszt <herbszt@gmx.de>
Subject: Status of SCSI referrals support in dm-multipath
Date: Sun, 1 Jun 2014 22:46:50 +0200
Message-ID: <20140601224650.000043de@localhost>
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
Cc: Sebastian Herbszt <herbszt@gmx.de>
List-Id: dm-devel.ids

Hello,

I am trying to find out the status of SCSI referrals support in dm-multipath.
SCSI referrals support was a topic at LSF [1] but I wasn't able to find any
information. Back in 2010 Hannes suggested the use of multiple entries in a
multipath table [2] but this doesn't seem to work (anymore):

[ 7750.354190] device-mapper: table: Request-based dm doesn't support multiple targets yet

Is there any SCSI referrals support yet?

[1] http://marc.info/?l=linux-scsi&m=129553880112460&w=2
[2] http://www.redhat.com/archives/dm-devel/2010-June/msg00155.html

Sebastian
