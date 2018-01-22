From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: Re: [PATCH] FIX "libmultipath: hwtable: multibus for
	NetApp NVMe-FC"
Date: Mon, 22 Jan 2018 21:53:16 +0100
Message-ID: <d990b792-cd8d-33e1-a3e8-ed06c81e764c@gmail.com>
References: <20180113211938.31552-10-mwilck@suse.com>
	<20180119115223.4625-1-mwilck@suse.com>
	<2ae5f020-e508-5cdd-0ada-d944ccba47f7@gmail.com>
	<1516374768.3534.1.camel@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1516374768.3534.1.camel@suse.com>
Content-Language: en-GB
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Martin Wilck <mwilck@suse.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

On 01/19/2018 04:12 PM, Martin Wilck wrote:

>>> +		.product       = "(NetApp |)ONTAP Controller",

> The device in question uses "NetApp ONTAP Controller" for the product
> (-> "model" in NVMe terms). IIUC there's older FW around that uses
> "ONTAP Controller" only.

.product       = "ONTAP Controller" should be enough,
it's shared by both strings.

But if an exact match is desired, ^ should be added at the
beginning.


Regex can be tested with: https://eli.thegreenplace.net/2012/11/14/some-notes-on-posix-regular-expressions
