From: Andy Grover <agrover@redhat.com>
Subject: Re: Getting device-mapper failure notifications
Date: Tue, 23 Feb 2016 21:00:45 -0800
Message-ID: <56CD38FD.9010209@redhat.com>
References: <CAHph7JrC0pU+Wy7DsHeCAhz7FWuJa29qGsdv+jD3OQq4aJ1bTA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <CAHph7JrC0pU+Wy7DsHeCAhz7FWuJa29qGsdv+jD3OQq4aJ1bTA@mail.gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Avishay Traeger <avishay@stratoscale.com>, dm-devel@redhat.com
List-Id: dm-devel.ids

On 02/01/2016 11:07 PM, Avishay Traeger wrote:
> Hi all,
> I have a system where various configurations are possible - iSCSI/FC,
> single paths and multiple.  For multiple I of course use device-mapper.
> I was wondering if it was possible to:
> 1. use it for cases where I have a single path.
> 2. create a monitoring process that can take some action (e.g., send a
> notification via message queue) in the case of some failure that would
> normally cause failover.

Does dm-multipath support a single path? I don't know...

but for your #2, dm-multipath publishes a uevent when a path fails, 
maybe the process could look for that? Using libudev?

HTH -- Andy
