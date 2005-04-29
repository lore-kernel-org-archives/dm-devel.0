From: k-ueda@ct.jp.nec.com
Subject: Re: what's up with pp_balance_units?
Date: Fri, 29 Apr 2005 11:31:44 -0400 (EDT)
Message-ID: <30273.7421975054$1114788357@news.gmane.org>
References: <1114720580.10504.7.camel@zezette>
	<20050428.175252.71083259.k-ueda@kde.biglobe.ne.jp@kde.biglobe.ne.jp>
	<1114728052.10504.12.camel@zezette>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1114728052.10504.12.camel@zezette>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
List-Id: dm-devel.ids

Hi Christophe,

On Fri, 29 Apr 2005 00:40:51 +0200, christophe varoqui wrote:
> You need to recheck with 0.4.5-pre1, as it is now allowed and encouraged
> to have (null) prio callouts. Does that look good ?

Yes, that does.
I confirmed that priority is set by "1", if I removed
"default_prio_callout" from multipath.conf.

But, it may be better if user can specify null callout explicitly.
Because, for example, user may want to specify that default is 
"pp_balance_units" but no callout is used for specific devices
like following.

---------------------------------------------------------
defaults {
    ...
    default_prio_callout   "/sbin/pp_balance_units %d"
    ...
}
devices {
    device {
        ...
        prio_callout       ""
        ...
    }
}
---------------------------------------------------------

Regards,
Ky (Kiyoshi Ueda)
