From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: [PATCH V7 2/4] multipath-tools: New way to limit the
 IPC command length.
Date: Fri, 12 Aug 2016 08:48:08 -0700
Message-ID: <560f83cc-2bd3-9f3d-7c27-34709f049cb0@sandisk.com>
References: <1453953120-7023-1-git-send-email-fge@redhat.com>
	<20160812121240.47796-1-fge@redhat.com>
	<20160812121240.47796-3-fge@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20160812121240.47796-3-fge@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Gris Ge <fge@redhat.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

On 08/12/2016 05:12 AM, Gris Ge wrote:
>     * Moved write_all() to file.h of libmultipath as all usage of
>       write_all() is against file rather than socket.

This sounds very wrong. As far as I can see write_all() is used to send 
data over a Unix socket. A Unix socket is not a file. Additionally, 
using write_all() to write to a file does not make sense. Please use 
write() to write to a file.

Bart.
