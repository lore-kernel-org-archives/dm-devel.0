From: Niel Lambrechts <antispam@telkomsa.net>
Subject: Buffer I/O errors
Date: Sun, 30 Apr 2006 13:55:56 +0200
Message-ID: <4454A5CC.20108@telkomsa.net>
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

I have a customer in a very remote location in Africa with the following
symptoms on a IBM serveRAID Linux system with dm and reiser3. I struggle
to get any info (all telephonically) but so far I have:

Buffer I/O error on dm-0
Lost page write due to I/O error
reiserfs: dm-0 journal write error in flush_commit_list

Is this necessarily h/w failure (like 2 or more disks failing in the
array), or are there other common problems related to these errors?
(perhaps cabling?)

Really, I simply need to confirm whether there could ever be a software
cause for this?

Regards
Niel
