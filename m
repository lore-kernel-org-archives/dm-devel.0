From: Jonathan E Brassow <jbrassow@redhat.com>
Subject: Re: dm panic debugging
Date: Mon, 21 Feb 2005 10:49:39 -0600
Message-ID: <0ff14b0dc3f58b65c81f589695de4d99@redhat.com>
References: <02051b97d69c0b43d83d677e535d040a@anu.edu.au>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0 (Apple Message framework v619.2)
Content-Type: text/plain; charset=US-ASCII; format=flowed
Content-Transfer-Encoding: 7bit
In-Reply-To: <02051b97d69c0b43d83d677e535d040a@anu.edu.au>
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

what are the test you are using.  I have a couple machines here I could 
probably have the tests running on.

  brassow

On Feb 21, 2005, at 9:32 AM, Tim Burgess wrote:

> Hi All,,
>
> I'm trying to debug this panic that I emailed the list about the other 
> day...  I've gotten a little way with KDB - just wondering if there's 
> someone familiar with the internals of dm-raid1 that I can bounce 
> things off as I find them (lest something I find jog inspiration with 
> someone who actually knows what's going on!).
>
> The crash occurs here in rh_dec(), called by mirror_end_io():
>
>         if (atomic_dec_and_test(&reg->pending)) {
>
> Because reg is a null pointer, returned by __rh_lookup()
>
> That's as far as I have gotten so far :)
>
> The crash is not complicated to reproduce but it does take quite a 
> while doing heavy i/o before it crops up.  So it might be an hour or 
> so before I can get back into my KDB session with the same problem 
> (there is a deadlock problem as well triggered by the same steps).
>
> Anyway - if someone is willing to lend a hand please let me know!!!
>
> Cheers,
> Tim
>
> -- 
>    tim.burgess@anu.edu.au         ANU Supercomputer Facility
>    Phone: +61 2 6125 1431           and APAC National Facility
>    Fax:   +61 2 6125 8199           Leonard Huxley Bldg (No. 56)
>                                     Australian National University
>                                     Canberra, ACT, 0200, Australia
>
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
>
