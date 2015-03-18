From: Sami Tolvanen <samitolvanen@google.com>
Subject: Re: [PATCH] dm-verity: Add error handling modes for
 corrupted blocks
Date: Wed, 18 Mar 2015 13:24:53 +0000
Message-ID: <20150318132453.GA3176@google.com>
References: <20150316155559.GA32397@google.com>
	<20150317152749.GA24901@redhat.com>
	<20150317160649.GA36193@google.com>
	<20150317180358.GD24901@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20150317180358.GD24901@redhat.com>
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
Cc: mpatocka@redhat.com, msb@chromium.org, wad@chromium.org
List-Id: dm-devel.ids

On Tue, Mar 17, 2015 at 02:03:58PM -0400, Vivek Goyal wrote:
> Without knowing too much of detail, asking kernel to restart because one
> block was corrupt sounds little drastic.
 
I agree, it's drastic, but in our use case it's necessary, because we have
critical system data on a verified partition. Depending on which blocks are
corrupted, the system may no longer be functional at this point.

> If you are sending user space events, why not let user space initiate the
> start and manage policy in user space.

We already manage policy in user space by determining in which mode dm-verity
will start. Restarting from user space is possible, but it would rely on the
uevent being reliably processed and the daemon responsible for restarting the
device not being blocked by the lack of access to corrupted data. We find
restarting from the dm-verity driver to be more reliable.

Sami
