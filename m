From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [git pull] device mapper changes for 4.12
Date: Wed, 3 May 2017 10:51:55 -0700
Message-ID: <CA+55aFx4w3eEpstfQWPJS=1XFX+qe11h6PAVk1=WjC55ODwegw@mail.gmail.com>
References: <20170502185847.GA79886@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20170502185847.GA79886@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mike Snitzer <snitzer@redhat.com>, Mikulas Patocka <mpatocka@redhat.com>
Cc: Somasundaram Krishnasamy <somasundaram.krishnasamy@oracle.com>, Adrian Salido <salidoa@google.com>, Heinz Mauelshagen <heinzm@redhat.com>, Eric Biggers <ebiggers@google.com>, Andy Shevchenko <andy.shevchenko@gmail.com>, Dennis Yang <dennisyang@qnap.com>, Milan Broz <gmazyland@gmail.com>, Vinothkumar Raja <vinraja@cs.stonybrook.edu>, Gilad Ben-Yossef <gilad@benyossef.com>, "dm-devel@redhat.com" <dm-devel@redhat.com>, Matthias Kaehlcke <mka@chromium.org>, Tim Murray <timmurray@google.com>, Ondrej Kozina <okozina@redhat.com>, Bart Van Assche <bart.vanassche@sandisk.com>, Joe Thornber <ejt@redhat.com>, Alasdair G Kergon <agk@redhat.com>
List-Id: dm-devel.ids

On Tue, May 2, 2017 at 11:58 AM, Mike Snitzer <snitzer@redhat.com> wrote:
>
> - Add a new DM integrity target that emulates a block device that has
>   additional per-sector tags that can be used for storing integrity
>   information.

So this one comes with a nice documentation file and everything, but
let me just quote all the help that you give users when faced with the
CONFIG_DM_INTEGRITY choice:

    CONFIG_DM_INTEGRITY:

    This is the integrity target.

That's it. Not really very helpful.

The kernel configuration phase is already likely the most frustrating
part of building your own kernel, it's really worth trying to make it
a *bit* less frustrating than this.

Even just a stupid little blurb that says

   "Emulates a block device that has additional per-sector tags that can
    be used for storing integrity information.

    If you're not sure, you can probably just say 'n'"

or something like that. People who use this likely know they use it,
and it should lower the stress level for others.

                   Linus
