From: "Bryn M. Reeves" <bmr@redhat.com>
Subject: Re: Device mapper target driver for Write tracking or
 Write split
Date: Fri, 9 Jan 2015 16:59:25 +0000
Message-ID: <20150109165924.GB17009@localhost.localdomain>
References: <e1aa69e2-7af2-4003-8b8c-5a2b6987a3e2@default>
	<20150109142313.GB24745@redhat.com>
	<a6164707-a0dc-426d-9324-a5fba2170682@default>
	<20150109151337.GA17009@localhost.localdomain>
	<932defdc-db0a-4f1d-9812-1685199aed3a@default>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <932defdc-db0a-4f1d-9812-1685199aed3a@default>
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
Cc: vgoyal@redhat.com
List-Id: dm-devel.ids

On Fri, Jan 09, 2015 at 07:51:08AM -0800, Suresh Babu Kandukuru wrote:
> Bryn, Thanks for quick reply. Below items helps to do mirroring and replication . I am looking for something which  can track writes( device mapper based block level filter driver)   as explained in the below diagram in Linux open source community .

Anything that's doing mirroring or replication (or many other useful
target functions) is going to need to 'track' writes (normally by
copying them and keeping track of the copies in the target).

The device-mapper core provides infrastructure to help with this but if
none of the existing dm targets provide the functionality you need then
you will either need to create one from scratch or extend whatever
current target best matches your needs.

Aside from mentioning CDP and replicating data to another appliance you
haven't really stated what you're trying to do.

Regards,
Bryn.
