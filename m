From: John Pittman <jpittman@redhat.com>
Subject: Re: dm cache: require io_mode cache feature selection to
	be mutually exclusive
Date: Wed, 27 Jun 2018 12:01:38 -0400
Message-ID: <CA+RJvhzmAuvrP5dKnK4OaOqx7VCHBNNY00PFxPiD0RWOg7pybw@mail.gmail.com>
References: <1529616933-11644-1-git-send-email-jpittman@redhat.com>
	<20180627152710.GA12017@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20180627152710.GA12017@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mike Snitzer <snitzer@redhat.com>
Cc: dm-devel@redhat.com, Laurence Oberman <loberman@redhat.com>
List-Id: dm-devel.ids

Hi Mike, thanks for replying and sorry for the lack of clarity on that
point.  In commit 629d0a8a1a10 the metadata2 feature was added. In
that same commit, to accommodate the new feature, the max feature args
was incremented to 2.  However, as it's written now, there is nothing
to keep those 2 args from both being io_mode feature args.  Prior to
that, the max feature args was only 1 and the user would just be
forced to pick from writeback, writethrough, or passthrough; the
io_mode args.

 static int parse_features(struct cache_args *ca, struct dm_arg_set *as,
                          char **error)
 {
        static struct dm_arg _args[] = {
-               {0, 1, "Invalid number of cache feature arguments"},
+               {0, 2, "Invalid number of cache feature arguments"},

Explaining how I hit the issue, in support we have scripts that
automatically pull information from the crash environment.  While
developing one of these scripts, I was duplicating the  raid_status
code and (iirc) I had to set a max feature arg myself.  I realized
that just setting to 2 would not work because specifying more than one
io_mode was possible.

When specified, they are all printed with the table. I assumed the
first one was applied, but I'm not sure and possibly/probably
incorrect.

I did open a medium sev RH bz1579002, if you'd like to see the output
from my system at the time.  No customer case associated, just thought
this may be a small oversight that could be fixed with a simple
counter.

On Wed, Jun 27, 2018 at 11:27 AM, Mike Snitzer <snitzer@redhat.com> wrote:
> On Thu, Jun 21 2018 at  5:35pm -0400,
> John Pittman <jpittman@redhat.com> wrote:
>
>> Due to commit 629d0a8a1a10 ("dm cache metadata: add "metadata2" feature"),
>> when creating a dm cache device, more than one io_mode can be selected.
>> As the io_mode selections are incompatible with one another, we should
>> force them to be selected exclusively.  Add simple ctr to check for
>> more than one io_mode selection.
>
> I'm missing why you're associating your fix with commit 629d0a8a1a10.
>
> Can you explain what you did to hit a problem that this patch is fixing?
> Did you list conflicting modes on the ctr and the last one in the table
> line won?
>
> Thanks,
> Mike
