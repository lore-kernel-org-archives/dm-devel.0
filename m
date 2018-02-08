From: Bart Van Assche <Bart.VanAssche@wdc.com>
Subject: Re: [PATCH 1/7] multipath: fix tur checker locking
Date: Thu, 8 Feb 2018 18:20:57 +0000
Message-ID: <1518114056.3611.60.camel@wdc.com>
References: <1518043787-7066-1-git-send-email-bmarzins@redhat.com>
	<1518043787-7066-2-git-send-email-bmarzins@redhat.com>
	<1518079760.15245.39.camel@suse.com>
	<20180208175205.GQ14513@octiron.msp.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20180208175205.GQ14513@octiron.msp.redhat.com>
Content-Language: en-US
Content-ID: <F828D303A280F44BAA98555791B5B48D@namprd04.prod.outlook.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: "bmarzins@redhat.com" <bmarzins@redhat.com>, "mwilck@suse.com" <mwilck@suse.com>
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Thu, 2018-02-08 at 11:52 -0600, Benjamin Marzinski wrote:
> On Thu, Feb 08, 2018 at 09:49:20AM +0100, Martin Wilck wrote:
> > On Wed, 2018-02-07 at 16:49 -0600, Benjamin Marzinski wrote:
> > > +		} else {
> > > +			/* locking here solely to make static
> > > analyzers happy */
> > 
> > Out of curiosity: which analyzers have you been using?
> 
> You would have to ask Bart, who I forgot to CC on this patch. He added
> the code to always read ct->thread in a spin_lock, and said it was to
> make an analyzer happy.

The analyzer I used is a dynamic analyzer, namely drd. See also
http://valgrind.org/docs/manual/drd-manual.html.

Bart.
