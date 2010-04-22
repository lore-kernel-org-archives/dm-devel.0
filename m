From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: Current shared snapshots
Date: Thu, 22 Apr 2010 17:01:22 -0400
Message-ID: <20100422210122.GA27637@redhat.com>
References: <Pine.LNX.4.64.1004200309030.24170@hs20-bc2-1.build.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.1004200309030.24170@hs20-bc2-1.build.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Tue, Apr 20 2010 at  3:15am -0400,
Mikulas Patocka <mpatocka@redhat.com> wrote:

> Hi
> 
> I uploaded current shared snapshots at 
> http://people.redhat.com/mpatocka/patches/kernel/new-snapshots/r19/
> 
> Changes: cache shrinking over time, removed unused code, documentation 
> changes from you.

When you included my dm-multisnapshot.txt changes my email's header
snuck in, this patch cleans that up:

diff --git a/Documentation/device-mapper/dm-multisnapshot.txt b/Documentation/device-mapper/dm-multisnapshot.txt
index cd0ff83..4ffa916 100644
--- a/Documentation/device-mapper/dm-multisnapshot.txt
+++ b/Documentation/device-mapper/dm-multisnapshot.txt
@@ -1,19 +1,3 @@
-From snitzer@redhat.com Tue Mar 30 12:27:02 2010
-Date: Tue, 30 Mar 2010 12:26:21 -0400
-From: Mike Snitzer <snitzer@redhat.com>
-To: Mikulas Patocka <mpatocka@redhat.com>
-Cc: device-mapper development <dm-devel@redhat.com>, Alasdair G Kergon <agk@redhat.com>
-Subject: Re: Shared snapshots
-
-On Wed, Dec 16 2009 at  3:39pm -0500,
-Mike Snitzer <snitzer@redhat.com> wrote:
-
-> As an aside, I have some ideas for improving
-> Documentation/device-mapper/dm-multisnapshot.txt
-> I'll just send a patch and we can go from there.
-
-OK, here is the updated dm-multisnapshot.txt (finally):
-
 Device-mapper multiple snapshot support
 =======================================
 
