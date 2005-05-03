From: christophe varoqui <christophe.varoqui@free.fr>
Subject: Re: default_prio_callout in multipath-tools-0.4.5-pre2
Date: Tue, 03 May 2005 23:52:55 +0200
Message-ID: <1115157176.2277.33.camel@zezette>
References: <20050503.172624.74755745.k-ueda@kde.biglobe.ne.jp@kde.biglobe.ne.jp>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20050503.172624.74755745.k-ueda@kde.biglobe.ne.jp@kde.biglobe.ne.jp>
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

Are you talking about the setting in multipath.conf.synthetic ?

If so, it is just there as a synthax example.
Nobody should copy this template in /etc/ without editing to fit its
needs.

The philosophy should be :

1. try first with no config file
2. if not satisfied, try to massage a config file
3. when satisfied, submit your tuning for inclusion in the default
hardware table.

For most users, there should only be aliases in the config file.

On mar, 2005-05-03 at 17:26 -0400, Kiyoshi Ueda wrote:
> Hi,
> 
> In multipath.conf of multipath-tools-0.4.5-pre2, "/bin/true" is set
> as default_prio_callout, but I think "none" is better as default.
> 
NULL is the default hardcoded conf->getprio (struct config is zalloc'ed)

> "/bin/true" assigns a priority value of "0" and "none" assigns
> that of "1", but the results are same according to the flat priority
> assignment.
> And "none" is more efficient, since "multipath" command doesn't
> call execute_program() which does fork() and exec().
> 
Right.

> Additionally, dependent commands can be reduced by using "none".
> It is helpful for / on multipath, since commands which need to be
> included in initramfs can be reduced when the default setting is used.
> 
> Any comments?
> 
You're all right, but I fail to see what you want me to change ... are
you saying you find the config templates misleading ?

Regards,
-- 
christophe varoqui <christophe.varoqui@free.fr>
