From: Andrei B <andrixnet@yahoo.com>
Subject: Re: Chicken and egg problem with multipath-tools
Date: Sun, 03 Mar 2013 23:01:37 +0200
Message-ID: <5133BA31.6080208@yahoo.com>
References: <1362220999.44153.YahooMailClassic@web126202.mail.ne1.yahoo.com>
	<kgvcv1$l3e$4@ger.gmane.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <kgvcv1$l3e$4@ger.gmane.org>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
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

Well, that would be an idea. However, multipathd has the pidfile
hardcoded. It cannot be changed at runtime, nor can it be disabled.

I know, I could compile it with a different hardcoded path, but that's
really a bad idea, because then if multipathd were to be restarted
anytime later after boot, it would then fail because of the same reason.


On 2013-03-03 01:42 PM, Gabriel de Perthuis wrote:
>> The problem is that multipathd wants to create a PID file under /var
>> (which is at this time readonly). This fails and multipathd fails to
>> start.
> Distros handle this by putting pidfiles in /run, a tmpfs set up at early 
> boot. There might be some magic to ensure that later mounts don't shadow 
> it.
>
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
