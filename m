From: "J. Hart" <af804@bfn.org>
Subject: retry:snapshots: COW drive capacity and monitoring space
	usage
Date: Thu, 08 Oct 2009 12:50:59 +0900
Message-ID: <4ACD61A3.3020407@bfn.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
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
Cc: af804@bfn.org
List-Id: dm-devel.ids

Greetings All,

I didn't see anything come back, so I'm giving it one last try.  I
apologize if this is a duplicate.

After having built my own distro up from source code (just to see if I
could), I've got snapshotting set up successfully on my system using the
kernel device mapping facility, dmsetup, and a COW drive.  I understand
from my reading that it is possible for the COW drive to run out of
space while it is in use.  Since it is not mounted and does not use a
filesystem as far as I know, I am wondering how one might go about
deciding on how big a drive to use, and monitoring space usage.  Any
information on this would be most appreciated.

J. Hart
