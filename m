From: Martin Wilck <mwilck@suse.com>
Subject: Re: [PATCH v3] libmultipath: Allow discovery of USB
 devices
Date: Tue, 29 Sep 2020 11:33:52 +0200
Message-ID: <afb1c6709dccc8068f0f0a38b9c26c6fb4733b74.camel@suse.com>
References: <AM0PR09MB289766D38FDC2D4F424B95AEFE350@AM0PR09MB2897.eurprd09.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <AM0PR09MB289766D38FDC2D4F424B95AEFE350@AM0PR09MB2897.eurprd09.prod.outlook.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Frank Meinl <frank.meinl@live.de>, dm-devel@redhat.com
List-Id: dm-devel.ids

On Mon, 2020-09-28 at 21:09 +0200, Frank Meinl wrote:
> This change adds a new configuration option allow_usb_devices. It is
> disabled by default, so that the behavior of existing setups is not
> changed. If enabled (via multipath.conf), USB devices will be found
> during device discovery and can be used for multipath setups.
> 
> Without this option, multipath currently ignores all USB drives,
> which
> is convenient for most users. (refer also to commit 51957eb)
> 
> However, it can be beneficial to use the multipath dm-module even if
> there is only a single path to an USB attached storage. In
> combination
> with the option 'queue_if_no_path', such a setup survives a temporary
> device disconnect without any severe consequences for the running
> applications. All I/O is queued until the device reappears.
> 
> Signed-off-by: Frank Meinl <frank.meinl@live.de>

Reviewed-by: Martin Wilck <mwilck@suse.com>
