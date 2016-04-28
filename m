From: Matthias Dahl <ml_linux-dm-devel@binary-island.eu>
Subject: Re: [4.4, 4.5,
 4.6] Regression: encrypted swap (dm-crypt) freezes system while
 under memory pressure and swapping
Date: Thu, 28 Apr 2016 11:04:02 +0200
Message-ID: <281fb825-8c01-ec00-2442-b91be891507f@binary-island.eu>
References: <26e0640c-40b0-5121-5d85-727d4fef82c5@binary-island.eu>
	<f42fde0f-fb4c-89a5-6199-bf7dd42c97d0@binary-island.eu>
	<5720D714.9010504@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------79430686CA0B7B28BA02655B"
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <5720D714.9010504@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
Cc: Ondrej Kozina <okozina@redhat.com>
List-Id: dm-devel.ids

This is a multi-part message in MIME format.
--------------79430686CA0B7B28BA02655B
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit

Hello Ondrej...

Thanks for taking the time.

On 27/04/16 17:13, Ondrej Kozina wrote:

> I observe that putting swap on top of dm-crypt (tested in current 4.6-rc
> kernel) have some unexpected side effects. Most notably it seems to me
> that oom killer joins the party quite prematurely even when there
> remains plenty of free swap space (almost all). But I didn't experience
> any permanent system freeze or crash. Just, let us dig deeper for a
> while...

Yes, 4.6-rc* behaves different from 4.4.x and >= 4.5-rc3 but it still
does not work correctly at all. You may want to try the little test
program I created and attached. I used it quite a lot to stress the system.

With that, you should have no problem seeing the described behavior on
the affected kernels. You may have to adjust the sleep a bit, depending
on your machine, though.

If there is anything else I can do to help, please let me know.

Have a nice day,
Matthias

-- 
Dipl.-Inf. (FH) Matthias Dahl | Software Engineer | binary-island.eu
 services: custom software [desktop, mobile, web], server administration

--------------79430686CA0B7B28BA02655B
Content-Type: text/x-c++src;
 name="main.cpp"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="main.cpp"

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>

int main(int argc, char** argv)
{
    unsigned long chunkSize = 1 << 20;       // 1 MiB per \ total mem alloc
    unsigned long maxRuns   = 8 * (1 << 10); // 2^10 runs / of 8 GiB
    void* buffer  = NULL;

    if(argc == 3)
    {
        chunkSize = atol(argv[1]);
        maxRuns   = atol(argv[2]);
    }

    unsigned long maxMemAllocInMB    = (chunkSize * maxRuns) / (1 << 20);
    unsigned long curMemAllocInBytes = 0;

    for(unsigned int i = 0; i < maxRuns; ++i)
    {
        buffer = malloc(chunkSize);
        memset(buffer, 0, chunkSize);

        curMemAllocInBytes += chunkSize;
        printf("%lu MB / %lu MiB allocated (%lu bytes).\n", (curMemAllocInBytes / (1 << 20)), maxMemAllocInMB, curMemAllocInBytes);

        usleep(500);
    }

    return 0;
}

--------------79430686CA0B7B28BA02655B
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--------------79430686CA0B7B28BA02655B--
