From: Bart Van Assche <Bart.VanAssche@sandisk.com>
Subject: Re: [PATCH] libmultipath: fix memory API logic error
Date: Mon, 15 Aug 2016 13:49:47 +0000
Message-ID: <SN1PR0201MB18708A10BD3C71F04CA0B36781120@SN1PR0201MB1870.namprd02.prod.outlook.com>
References: <ee311fa6-305e-f3a9-b4c2-a81b31bdd732@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Language: en-US
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Xose Vazquez Perez <xose.vazquez@gmail.com>, "tang.junhui " <tang.junhui@zte.com.cn>, device-mapper development <dm-devel@redhat.com>, Christophe Varoqui <christophe.varoqui@opensvc.com>
List-Id: dm-devel.ids

On 08/15/16 05:11, Xose Vazquez Perez wrote:
> libmultipath/memory.[ch] files along with libmultipath/parser.[ch] and
> libmultipath/vector.[ch] come from keepalived/lib/ [1] .
>
> Maybe it's worth to backport their fixes and new features.

Hello Xose,

Are you aware that there are tools available that are much more powerful 
than keepalived's memory.[ch]? See e.g. 
http://valgrind.org/info/tools.html#massif.

Bart.
