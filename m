From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: [PATCH] multipathd: fix issue in 'map $map
 getprstatus' reply
Date: Thu, 13 Oct 2016 15:43:40 -0700
Message-ID: <15f01890-16ca-3c05-716a-e07b66e344fb@sandisk.com>
References: <OF841ED337.71FB1AB0-ON4825804A.000FE81D-4825804A.0010D15C@zte.com.cn>
	<2024ba47-6117-da6b-52cf-2450ddd7c30b@sandisk.com>
	<OF4C00E53C.5638BD7E-ON4825804B.0021C9DD-4825804B.0023B30C@zte.com.cn>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <OF4C00E53C.5638BD7E-ON4825804B.0021C9DD-4825804B.0023B30C@zte.com.cn>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: peng.liang5@zte.com.cn
Cc: zhang.kai16@zte.com.cn, dm-devel@redhat.com, tang.junhui@zte.com.cn
List-Id: dm-devel.ids

On 10/12/2016 11:30 PM, peng.liang5@zte.com.cn wrote:
> Thanks for your attention. I don't think it is necessary to do that.
> Whatever returning 1 or ENOMEM it will reply "fail\n" and set the
> returning to 1.
>
> The executed code in uxsock_trigger as follows.
>         if (r > 0) {
>                 if (r == ETIMEDOUT)
>                         *reply = STRDUP("timeout\n");
>                 else
>                         *reply = STRDUP("fail\n");
>                 *len = strlen(*reply) + 1;
>                 r = 1;
>         }

Hello Peng,

Anyone who wants to verify your patch has to look up the numeric value 
of ETIMEDOUT to see whether or not the value of that constant is equal 
to one. So using "return 1" makes the source code harder to read than 
"return ENOMEM". Additionally, it is inconsistent from a stylistic point 
of view that the caller compares the return value with an E... error 
code and that the called function returns a numeric constant. So I would 
appreciate it very much if you would change "return 1" into "return 
ENOMEM" or any other symbolic E* error code of your preference.

Bart.
