From: Sami Tolvanen <samitolvanen@google.com>
Subject: Re: [PATCH] dm-verity: Add error handling modes for
 corrupted blocks
Date: Tue, 17 Mar 2015 16:06:49 +0000
Message-ID: <20150317160649.GA36193@google.com>
References: <20150316155559.GA32397@google.com>
	<20150317152749.GA24901@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20150317152749.GA24901@redhat.com>
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

On Tue, Mar 17, 2015 at 11:27:49AM -0400, Vivek Goyal wrote:
> What's the idea behind kernel restart mode ? If a corrupted block is in
> the path of boot, will we not get into a continuous reboot cycle.

It depends on how dm-verity is used. If we have PSTORE_CONSOLE enabled, for
example, after a restart we can check if the restart was caused by dm-verity
and then use a different mode when setting up the verity device. Most likely
for some systems this is not a reasonable recovery method, but we find it to
be useful on Android at least.

Sami
