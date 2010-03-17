From: Christophe Varoqui <christophe.varoqui@gmail.com>
Subject: Re: [PATCH] multipath: display average priority as group
	priority
Date: Wed, 17 Mar 2010 22:49:20 +0100
Message-ID: <1268862560.4598.1.camel@zezette>
References: <201003171244.25957.knikanth@suse.de>
Reply-To: christophe.varoqui@opensvc.com,
        device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <201003171244.25957.knikanth@suse.de>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Nikanth Karthikesan <knikanth@suse.de>
Cc: dm-devel <dm-devel@redhat.com>
List-Id: dm-devel.ids

> Now average priority is used as path group priority, instead of sum of
> priorities of the paths. But while displaying group priority, sum is
> being displayed. Change it to print the average priority.
> 
> When there are no enabled paths, print 0 as priority.
> 
Applied.
Thanks.
