From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Current shared snapshots
Date: Tue, 20 Apr 2010 03:15:03 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.1004200309030.24170@hs20-bc2-1.build.redhat.com>
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
To: redhat.com@redhat.com
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

Hi

I uploaded current shared snapshots at 
http://people.redhat.com/mpatocka/patches/kernel/new-snapshots/r19/

Changes: cache shrinking over time, removed unused code, documentation 
changes from you.

It doesn't contain variable renaming patches that you sent me, I think 
it's not needed and also --- renaming variables with regular expressions 
is dangerous. It may patch something that wasn't intended to be patched.

Mikulas
