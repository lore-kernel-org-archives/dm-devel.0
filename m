From: Christoph Hellwig <hch@infradead.org>
Subject: Re: block mapping
Date: Thu, 29 Sep 2011 09:55:18 -0400
Message-ID: <20110929135518.GA3639@infradead.org>
References: <CALLzPKaWVR5=+S7QtHRpPBkDR5SVsZEAhbUn+G09o1S9JhjFOw@mail.gmail.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <CALLzPKaWVR5=+S7QtHRpPBkDR5SVsZEAhbUn+G09o1S9JhjFOw@mail.gmail.com>
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

On Thu, Sep 29, 2011 at 04:35:44PM +0300, Kasatkin, Dmitry wrote:
> Hello All,
> 
> I would like to implement such block device, which can store
> additional information along with the block data.
> For example. so if file system has 4k block, I would like to store
> 4k+256b of additional information...
> 
> Can such block device be implemented with device mapper?

Given your other recent posts you probably want to take a look at
dm-verity:

	http://selinuxproject.org/~jmorris/lss2011_slides/LSS_11_Integrity_checked_block_devices.pdf

(even if that's not strictly what you are asking for here)
