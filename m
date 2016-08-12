From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: [PATCH V7 1/4] libmpathcmd: Block SIGPIPE when
	write()
Date: Fri, 12 Aug 2016 09:01:05 -0700
Message-ID: <1b532987-d3dd-ddba-4c9d-981e2e127d3c@sandisk.com>
References: <1453953120-7023-1-git-send-email-fge@redhat.com>
	<20160812121240.47796-1-fge@redhat.com>
	<20160812121240.47796-2-fge@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20160812121240.47796-2-fge@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Gris Ge <fge@redhat.com>, dm-devel@redhat.com
List-Id: dm-devel.ids

On 08/12/2016 05:12 AM, Gris Ge wrote:
>  * Just block SIGPIPE when write() and restore it when done.
>  * Use 'errno_save()' to preserve the errno of write().

Hello Gris,

Why do you want to block SIGPIPE around a write() call that you want to 
use to write to a file? If you use write_all() to write to stdout then 
blocking SIGPIPE sounds wrong to me.

Thanks,

Bart.
