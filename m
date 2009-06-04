From: David Strand <dpstrand@gmail.com>
Subject: Re: blk_abort_queue on failed paths?
Date: Wed, 3 Jun 2009 18:43:45 -0700
Message-ID: <448b15030906031843n3a9ba6f6see6a7107c21386ee@mail.gmail.com>
References: <448b15030906021555j4e476193kcf69e019992dc592@mail.gmail.com>
	<4A26ED7D.1010203@cs.wisc.edu>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <4A26ED7D.1010203@cs.wisc.edu>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
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

On Wed, Jun 3, 2009 at 2:39 PM, Mike Christie <michaelc@cs.wisc.edu> wrote:
> What driver were you using?

I am using an LSI FC hba, which uses the mptfc driver.
