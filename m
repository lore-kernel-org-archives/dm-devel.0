From: Sami Tolvanen <samitolvanen@google.com>
Subject: Re: [bug report] dm verity: add support for forward
	error correction
Date: Thu, 14 Jun 2018 08:54:43 -0700
Message-ID: <CABCJKuecCQW-DtG7SdZHq56jeNk+vCy4qS5NJxFmhg0bA7uz+g@mail.gmail.com>
References: <20180614143315.z3adjqzgjjvdxvjr@kili.mountain>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20180614143315.z3adjqzgjjvdxvjr@kili.mountain>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dan.carpenter@oracle.com
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

On Thu, Jun 14, 2018 at 7:33 AM Dan Carpenter <dan.carpenter@oracle.com> wrote:
> Apparently, if the read is a blocking read then new_read() returns NULL.

It looks like new_read can return NULL only if it's called with NF_GET
or NF_PREFETCH. dm_bufio_read calls it with NF_READ, which means it
shouldn't return NULL. Someone more familiar with dm-bufio, please
correct me if I'm wrong.

Sami
