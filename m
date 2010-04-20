From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: Current shared snapshots
Date: Tue, 20 Apr 2010 11:03:40 -0400
Message-ID: <20100420150340.GD7538@redhat.com>
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
> 
> It doesn't contain variable renaming patches that you sent me, I think 
> it's not needed and also --- renaming variables with regular expressions 
> is dangerous. It may patch something that wasn't intended to be patched.

That is unfortunate.  I guess I won't waste my time on such cleanups in
the future.  Seriously, dismissing those changes as "not needed" is
frustrating.  Those changes really do serve to add consistency.

Your concern about using regex to do renames is valid but hardly reason
to dismiss changes.  Any unwanted change is easily caught by compiling
the result.

I really do hope you'll reconsider taking those rename changes.  I'll
refresh and re-review the changes against r19 if you're willing to
reconsider.

Mike
