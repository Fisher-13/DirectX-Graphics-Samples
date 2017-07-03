//
// Copyright (c) Microsoft. All rights reserved.
// This code is licensed under the MIT License (MIT).
// THIS CODE IS PROVIDED *AS IS* WITHOUT WARRANTY OF
// ANY KIND, EITHER EXPRESS OR IMPLIED, INCLUDING ANY
// IMPLIED WARRANTIES OF FITNESS FOR A PARTICULAR
// PURPOSE, MERCHANTABILITY, OR NON-INFRINGEMENT.
//
// Developed by Minigraph
//
// Author:  James Stanard 
//

#include "BitonicSortCommon.hlsli"

RWStructuredBuffer<uint2> g_SortBuffer : register(u0);

cbuffer Constants : register(b0)
{
    uint k;		// k >= 4096
    uint j;		// j >= 2048 && j < k
};

[RootSignature(BitonicSort_RootSig)]
[numthreads(1024, 1, 1)]
void main( uint3 DTid : SV_DispatchThreadID  )
{
    // Form unique index pair from dispatch thread ID
    uint Index1 = InsertZeroBit(DTid.x, j);
    uint Index2 = Index1 | j;

    uint2 A = g_SortBuffer[Index1];
    uint2 B = g_SortBuffer[Index2];

    if (ShouldSwap(A, B, Index1, k))
    {
        g_SortBuffer[Index1] = B;
        g_SortBuffer[Index2] = A;
    }
}
