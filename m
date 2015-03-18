From: Sami Tolvanen <samitolvanen@google.com>
Subject: Re: [PATCH] dm-verity: Add error handling modes for
 corrupted blocks
Date: Wed, 18 Mar 2015 15:49:51 +0000
Message-ID: <20150318154951.GA29369@google.com>
References: <20150316155559.GA32397@google.com>
	<20150317152749.GA24901@redhat.com>
	<20150317160649.GA36193@google.com>
	<20150317180358.GD24901@redhat.com>
	<20150318132453.GA3176@google.com>
	<alpine.LRH.2.02.1503181135461.29107@file01.intranet.prod.int.rdu2.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.02.1503181135461.29107@file01.intranet.prod.int.rdu2.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: device-mapper development <dm-devel@redhat.com>, wad@chromium.org, msb@chromium.org
List-Id: dm-devel.ids

On Wed, Mar 18, 2015 at 11:42:47AM -0400, Mikulas Patocka wrote:
> I hope that you at least turn this feature off after a few reboots and 
> give the user a chance to save his data.

Of course. We prompt the user after the reboot and ask them if they want
to proceed using the device without verification. We don't want to disable
verification before the user has been notified though.

Sami
