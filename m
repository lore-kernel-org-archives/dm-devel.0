From: Bart Van Assche <Bart.VanAssche@wdc.com>
Subject: Re: [RFC PATCH 19/20] multipathd: use foreign API
Date: Fri, 2 Mar 2018 21:00:07 +0000
Message-ID: <1520024406.2855.22.camel@wdc.com>
References: <20180220132658.22295-1-mwilck@suse.com>
	<20180220132658.22295-20-mwilck@suse.com>
	<20180301051306.GO14513@octiron.msp.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20180301051306.GO14513@octiron.msp.redhat.com>
Content-Language: en-US
Content-ID: <38BC60C1E0171C44AF6DB66E3D9C4C6F@namprd04.prod.outlook.com>
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

On Wed, 2018-02-28 at 23:13 -0600, Benjamin Marzinski wrote:
> Now assuming signal processing worked correctly in multipathd (it doesn't.
> commit 534ec4c broke it. I'm planning on fixing that shortly) there would
> still be a problem, because of the strict_timing option.

Although I'm not convinced that there is anything wrong with commit 534ec4c:
if you want to change signal handling in multipathd please retest multipathd
with Valgrind. Although Valgrind's signal handling is POSIX compliant it
handles signal delivery different than the Linux kernel.

Bart.
