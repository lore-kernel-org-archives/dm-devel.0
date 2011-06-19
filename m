From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: newbie question regarding target_type's map callback
Date: Sun, 19 Jun 2011 02:48:06 +0100
Message-ID: <20110619014806.GI19996@agk-dp.fab.redhat.com>
References: <1308412649.23392.621.camel@linux-zhyd.site>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1308412649.23392.621.camel@linux-zhyd.site>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Krzysztof =?utf-8?Q?B=C5=82aszkowski?= <kb@sysmikro.com.pl>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

All I can suggest is studying the existing upstream targets to
understand better how they work and perhaps avoid problems like the ones
you are seeing.

What is your target trying to do?
(Why is split_io important?  Did you implement a merge fn?)

Alasdair
