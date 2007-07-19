From: Brian De Wolf <bldewolf@csupomona.edu>
Subject: multipath-tool udev rules require missing dmsetup
	features
Date: Wed, 18 Jul 2007 18:04:01 -0700
Message-ID: <469EB881.6070207@csupomona.edu>
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
To: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

Hello,

Recently I've been using the latest git versions of multipath-tools and I've
noticed that the udev rules that are included, specifically those for kpartx,
refer to environment variables such as DM_TABLE_STATE, DM_PART, DM_UUID, etc.
However, the kpartx.rules file contains nothing that would bring those
environment variables into the environment.  After some googling, I found
http://ftp.frugalware.org/pub/frugalware/frugalware-current/source/lib/device-mapper/
which has a patch that adds a command to dmsetup called 'export'.  I've found
various udev scripts that use this command to pull the environment variables I
listed before for use in udev rules and the multipath-tools kpartx.rules file
itself works perfectly when the correct 'dmsetup export' command is imported.

What really puzzles me is that this patch was very difficult to find, but is
essential to the 'official' multipath-tools udev rules.  Is there something that
I'm missing that makes this all make sense?

Thanks!
Brian De Wolf
