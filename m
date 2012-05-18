From: Joe Thornber <thornber@redhat.com>
Subject: Re: [PATCH v2] dm thin: fix table output when pool
 target disables discard passdown internally
Date: Fri, 18 May 2012 16:14:28 +0100
Message-ID: <20120518151427.GA24493@ubuntu>
References: <1337310059-8517-1-git-send-email-snitzer@redhat.com>
	<1337353441-12647-1-git-send-email-snitzer@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1337353441-12647-1-git-send-email-snitzer@redhat.com>
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

On Fri, May 18, 2012 at 11:04:01AM -0400, Mike Snitzer wrote:
> When the thin pool target clears the discard_passdown parameter
> internally, it incorrectly reports this to userspace on the table line.
> This patch corrects this by no longer changing the table line to reflect
> that discard passdown was disabled.
> 
> We can still tell when discard passdown is overridden by looking for the
> message "Discard unsupported by data device (sdX): Disabling discard passdown."
> 
> Signed-off-by: Mike Snitzer <snitzer@redhat.com>

Ack
