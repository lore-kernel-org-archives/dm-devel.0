From: Christophe Varoqui <christophe.varoqui@free.fr>
Subject: Re: User friendly names patch.
Date: Tue, 25 Oct 2005 21:37:41 +0200
Message-ID: <1130269061.13850.26.camel@zezette>
References: <20051021233521.GA32160@phlogiston.msp.redhat.com>
	<1129967524.7313.65.camel@zezette>
	<20051024164902.GB19176@phlogiston.msp.redhat.com>
	<20051025084121.GA17494@free.fr>
	<20051025191749.GL19176@phlogiston.msp.redhat.com>
Reply-To: christophe.varoqui@free.fr,
	device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20051025191749.GL19176@phlogiston.msp.redhat.com>
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


> How about I make the bindings file location configurable, so that everyone
> can be happy with the location? I'll leave the default location where it
> is now when I send the patch.  If you would like to change it to someplace in
> /etc when you commit it, go ahead.
> 
Agreed, I guess we can get off with a multipath(8) flag to specify an
exotic location in the init{rd,ramfs} and leave the normal location
in /var.

I merged the patch as-is today.

Can you craft a patch to move the bindings file locking method from
"non-block + retry" to "block + timeout", if it makes sense to you too.

Regards,
cvaroqui
