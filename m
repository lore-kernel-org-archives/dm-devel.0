From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: RFC for multipath queue_if_no_path timeout.
Date: Thu, 26 Sep 2013 18:24:22 +0100
Message-ID: <20130926172422.GA31328@agk-dp.fab.redhat.com>
References: <1380215696.25252.36.camel@bobble.lax.corp.google.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1380215696.25252.36.camel@bobble.lax.corp.google.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Frank Mayhar <fmayhar@google.com>
Cc: dm-devel <dm-devel@redhat.com>
List-Id: dm-devel.ids

Timeouts were discussed when we added queue_if_no_path. and we made the
decision to implement this in userspace not the kernel.

Make sure that your daemon doesn't die - or that something monitors it
and relaunches it if it does.

Alasdair
