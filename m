From: Martin Wilck <mwilck@suse.com>
Subject: Re: [PATCH v2 17/21] libmultipath: add udev and logsink
	symbols
Date: Sat, 26 Sep 2020 01:05:49 +0200
Message-ID: <d805accf2c3c05df002fe486c3b30b7f6811a5a7.camel@suse.com>
References: <20200924133716.14120-1-mwilck@suse.com>
	<20200924133716.14120-18-mwilck@suse.com>
	<20200925230343.GD3384@octiron.msp.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20200925230343.GD3384@octiron.msp.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

On Fri, 2020-09-25 at 18:03 -0500, Benjamin Marzinski wrote:
> 
> I don't understand why we need both _udev_init() and
> _libmultipath_init().

Just in case we need more initialization in the future, then we could
add _foo_init(). Not important of course, I can change  it back.

Cheers,
Martin
