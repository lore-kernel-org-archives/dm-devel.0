From: Phillip Susi <psusi@cfl.rr.com>
Subject: Re: Reply-to munging
Date: Mon, 02 Jul 2007 15:55:56 -0400
Message-ID: <4689584C.4030500@cfl.rr.com>
References: <46785289.6010602@cfl.rr.com>
	<20070620144458.GH25016@agk.fab.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20070620144458.GH25016@agk.fab.redhat.com>
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

Alasdair G Kergon wrote:
> And here are some counter-arguments:
>   http://www.metasystema.net/essays/reply-to.mhtml

And they would be wrong:

> The Principle of Minimal Bandwidth

I don't see how forcing a reply that otherwise was intended to go only 
to one recipient to be sent out to the entire list saves bandwidth.

> Reply-To Munging Adds Something

No, it does not; it takes away something.  If you want to reply publicly 
then you use reply-to-all.  It is up to the SENDER to set their 
Reply-To: header if they do NOT want a reply going to them as well as 
the list.  They should make that choice, not the replier.  Users also 
are supposed to be able to use Reply-To: to direct replies to the 
correct sender in the event that they forward a message on someone 
else's behalf.  Thirdly, munging the header breaks the reply 
functionality of the client by making it behave like reply-to-all.

> It Doesn't Break Reasonable Mailers

Yes, it does.  This argument boils down to "Breaking the reply function 
isn't really breaking it because some mailers have added a 
reply-ignoring-broken-munged-reply-to function that you can use 
instead".  If the headers weren't munged in the first place this option 
would not be needed.

> Freedom of Choice

This one could not be more of a bold faced lie.  The only "freedom" it 
adds is the replier's freedom to take away the freedom of the sender and 
force a reply only to the list despite their wishes otherwise, as 
reflected by the reply-to: header they did or did not set.

> Some Mailers are Broken

Same fallacious argument as "It Doesn't Break Reasonable Mailers".  It 
is mailing lists that munge that are broken, not clients that have not 
added a 3rd reply option specifically to deal with such broken lists.

> Principle of Least Total Work

Again, it is up to the poster to decide if they want a reply directly to 
them, or only to the list, not the replier.  If they want their own 
reply, then give it to them.

> People are Responsible for Their Own Mistakes

This item simply dismisses the principal of least surprise in favor of 
codling the ignorant.  User mistakes are no longer their fault when your 
mailing list causes an unexpected change in the behavior of their mailer.
