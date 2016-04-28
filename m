From: Matthias Dahl <ml_linux-dm-devel@binary-island.eu>
Subject: Re: [4.4, 4.5,
 4.6] Regression: encrypted swap (dm-crypt) freezes system while
 under memory pressure and swapping
Date: Thu, 28 Apr 2016 11:24:58 +0200
Message-ID: <ac588d84-2610-cc50-1ec9-5e6097ce5f99@binary-island.eu>
References: <26e0640c-40b0-5121-5d85-727d4fef82c5@binary-island.eu>
	<f42fde0f-fb4c-89a5-6199-bf7dd42c97d0@binary-island.eu>
	<5720D714.9010504@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------101A1D3317C87831FD1FBE57"
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
--------------101A1D3317C87831FD1FBE57
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit

Hello Ondrej...

Sorry, I somehow managed to sent you the wrong version of the little C
program. I wanted to clean it up before sending it and you got a nice
in-between version between the old and new one. :-)

Double-checked now, that's the right one. Sorry.

Have a nice day,
Matthias

-- 
Dipl.-Inf. (FH) Matthias Dahl | Software Engineer | binary-island.eu
 services: custom software [desktop, mobile, web], server administration


--------------101A1D3317C87831FD1FBE57
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
        chunkSize = strtoul(argv[1], NULL, 10);
        maxRuns   = strtoul(argv[2], NULL, 10);
    }

    unsigned long maxMemAllocInBytes = chunkSize * maxRuns;
    unsigned long maxMemAllocInMB    = maxMemAllocInBytes / (1 << 20);
    unsigned long curMemAllocInBytes = 0;

    while(curMemAllocInBytes < maxMemAllocInBytes)
    {
        buffer = malloc(chunkSize);
        memset(buffer, 0, chunkSize);

        curMemAllocInBytes += chunkSize;
        printf("%lu MB / %lu MiB allocated (%lu bytes).\n", (curMemAllocInBytes / (1 << 20)), maxMemAllocInMB, curMemAllocInBytes);

        usleep(500);
    }

    return 0;
}

--------------101A1D3317C87831FD1FBE57
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--------------101A1D3317C87831FD1FBE57--
