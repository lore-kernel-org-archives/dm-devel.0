From: Christophe Varoqui <christophe.varoqui@free.fr>
Subject: Re: crash in multipathd
Date: Sun, 30 Jan 2005 21:59:24 +0100
Message-ID: <20050130205924.GA5570@zezette>
References: <CC9E49E3-72FD-11D9-8EBB-000A95A2734C@nanisky.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <CC9E49E3-72FD-11D9-8EBB-000A95A2734C@nanisky.com>
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

> 
> please advice, should I try to compile my own version?
> 
You should try that , yes.
If it fixes the problem, you should report to Debian, as they added a
patch to inhibit the pidfile logic in the daemon since 0.4.2

regards,
cvaroqui

--
dm-devel mailing list
dm-devel@redhat.com
https://www.redhat.com/mailman/listinfo/dm-devel
