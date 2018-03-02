From: Bart Van Assche <Bart.VanAssche@wdc.com>
Subject: Re: [PATCH] multipathd: fix inverted signal blocking
	logic
Date: Fri, 2 Mar 2018 22:23:46 +0000
Message-ID: <1520029421.2855.35.camel@wdc.com>
References: <20180302200048.GJ14513@octiron.msp.redhat.com>
	<20180302211807.11434-1-mwilck@suse.com>
	<1520026513.2855.30.camel@wdc.com>
	<1520028909.4169.87.camel@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1520028909.4169.87.camel@suse.com>
Content-Language: en-US
Content-ID: <B61BFC7039283F478707ED8EF267E96D@namprd04.prod.outlook.com>
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

On Fri, 2018-03-02 at 23:15 +0100, Martin Wilck wrote:
> On Fri, 2018-03-02 at 21:35 +0000, Bart Van Assche wrote:
> > This change looks more complicated to me than necessary. Have you
> > considered
> > to pass an empty signal set as the fourth ppoll() argument?
> 
> An empty set would mean that no signal is blocked during ppoll().
> Therefore e.g. SIGALRM would terminate multipathd if it arrives
> during the ppoll (no handler set, and default action is "Term").

Have you considered to only block SIGALRM while ppoll() is in progress?

Thanks,

Bart.
