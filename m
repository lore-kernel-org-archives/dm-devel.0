From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: [PATCH 15/15] Makefile.inc: Enable -Wextra and
 -Wformat-nonliteral
Date: Mon, 10 Oct 2016 12:55:15 -0700
Message-ID: <ed6d4ecb-9460-d11a-da65-fea477fb6ac8@sandisk.com>
References: <e3558026-9180-42a3-97ae-1f8fe66938de@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <e3558026-9180-42a3-97ae-1f8fe66938de@gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Xose Vazquez Perez <xose.vazquez@gmail.com>, device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On 10/10/2016 12:17 PM, Xose Vazquez Perez wrote:
> With this patch, clang is emitting four new warnings:

Hello Xose,

-Wformat-nonliteral helped me to catch a real bug. How about suppressing 
these warnings with a #pragma statement (see also 
http://clang.llvm.org/docs/UsersManual.html#controlling-diagnostics-via-pragmas)?

Bart.
