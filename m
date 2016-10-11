From: Heinz Mauelshagen <heinzm@redhat.com>
Subject: Re: [dm-devel] [PATCH 1/1] dm raid: fix compat_features validation
Date: Tue, 11 Oct 2016 17:44:21 +0200
Message-ID: <591b9d8d-2036-2d0f-14f2-af176b5beaea@redhat.com>
References: <20161011142835.11620-1-apw@canonical.com>
 <1c517f14-1234-7844-fc6a-cd1b9698fb8b@redhat.com>
 <20161011153808.nmyf6hafjaadcemw@brain>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20161011153808.nmyf6hafjaadcemw@brain>
Sender: linux-kernel-owner@vger.kernel.org
To: Andy Whitcroft <apw@canonical.com>
Cc: Mike Snitzer <snitzer@redhat.com>, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, dm-devel@redhat.com, Shaohua Li <shli@kernel.org>, Alasdair Kergon <agk@redhat.com>
List-Id: dm-devel.ids



On 10/11/2016 05:38 PM, Andy Whitcroft wrote:
> On Tue, Oct 11, 2016 at 05:04:34PM +0200, Heinz Mauelshagen wrote:
>> Andy,
>>
>> good catch.
>>
>> We should rather check for  V190 support only in case any
>> compat feature flags are actually set.
>>
>> {
>> +       if (le32_to_cpu(sb->compat_features) &&
>> +           le32_to_cpu(sb->compat_features) != FEATURE_FLAG_SUPPORTS_V190)
>> {
>>                  rs->ti->error = "Unable to assemble array: Unknown flag(s)
>> in compatible feature flags";
>>                  return -EINVAL;
>>          }
> If the feature flags are single bit combinations then I believe the
> below does check exactly that.  Checking for no 1s outside of the
> expected features, caring not for the value of the valid bits:
>
> +     if (le32_to_cpu(sb->compat_features) & ~(FEATURE_FLAG_SUPPORTS_V190)) {
>
> with the possibilty to or in additional feature bits as they are added.

Thanks,
I prefer this to be easier readable.

>
> -apw
>
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
